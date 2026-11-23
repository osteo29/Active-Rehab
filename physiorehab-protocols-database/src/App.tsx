/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect } from 'react';
import ProtocolDetail from './components/ProtocolDetail';
import { db, auth } from './lib/firebase';
import { collection, onSnapshot, query, addDoc, getDoc, doc } from 'firebase/firestore';
import { onAuthStateChanged, signInWithPopup, GoogleAuthProvider, signOut } from 'firebase/auth';
import { Activity, LogIn, LogOut, Plus, Search, Loader2 } from 'lucide-react';

export default function App() {
  const [protocols, setProtocols] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedProtocol, setSelectedProtocol] = useState<any | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [activeCategory, setActiveCategory] = useState('All');
  const [user, setUser] = useState<any>(null);
  const [loadError, setLoadError] = useState<string | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);

  useEffect(() => {
    const unsubAuth = onAuthStateChanged(auth, async (u) => {
      setUser(u);
      if (u) {
        try {
          const adminDoc = await getDoc(doc(db, 'admins', u.uid));
          setIsAdmin(adminDoc.exists() || u.email === 'activerehab0@gmail.com');
        } catch (e) {
          console.error("Admin check failed", e);
          setIsAdmin(u.email === 'activerehab0@gmail.com');
        }
      } else {
        setIsAdmin(false);
      }
    });

    const q = query(collection(db, 'protocols'));
    const unsubProtocols = onSnapshot(q, (snapshot) => {
      const data = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
      setProtocols(data);
      setLoadError(null);
      setLoading(false);
    }, (error) => {
      console.error('Protocols listener failed', error);
      setLoadError('تعذر تحميل البروتوكولات. يرجى التحقق من الاتصال والمحاولة مرة أخرى. / Could not load protocols. Please check your connection and try again.');
      setLoading(false);
    });

    return () => {
      unsubAuth();
      unsubProtocols();
    };
  }, []);

  const categories = ['All', ...new Set(protocols.map(p => p.category))];

  const filteredProtocols = protocols.filter(p => {
    const matchesSearch = p.name.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = activeCategory === 'All' || p.category === activeCategory;
    return matchesSearch && matchesCategory;
  });

  const handleLogin = async () => {
    const provider = new GoogleAuthProvider();
    try {
      await signInWithPopup(auth, provider);
    } catch (e) {
      console.error("Login failed", e);
    }
  };

  const handleLogout = () => signOut(auth);

  const clearDatabase = async () => {
    if (!isAdmin) return;
    if (!confirm("Are you sure you want to delete all protocols? This cannot be undone.")) return;
    
    try {
      setLoading(true);
      const { getDocs, deleteDoc, doc } = await import('firebase/firestore');
      const snapshot = await getDocs(collection(db, 'protocols'));
      for (const d of snapshot.docs) {
        await deleteDoc(doc(db, 'protocols', d.id));
      }
      alert("Database cleared successfully!");
    } catch (e) {
      console.error("Clear failed", e);
    } finally {
      setLoading(false);
    }
  };

  const seedDatabase = async () => {
    if (!isAdmin) return;
    try {
      setLoading(true);
      const { default: fullData } = await import('../full_protocols.json');
      
      // We'll upload in chunks
      for (const p of fullData) {
        await addDoc(collection(db, 'protocols'), {
          ...p,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        });
      }
      alert(`Successfully seeded ${fullData.length} protocols with full details (Precautions, Criteria, Cues) from the book!`);
    } catch (e) {
      console.error("Seeding failed", e);
      alert("Error seeding database. Check console.");
    } finally {
      setLoading(false);
    }
  };

  if (loadError) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center bg-slate-50 px-4 text-center">
        <Activity className="w-8 h-8 text-rose-500 mb-4" />
        <p className="text-slate-600 font-medium max-w-md">{loadError}</p>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-50">
        <Loader2 className="w-8 h-8 text-blue-600 animate-spin" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50 font-sans text-slate-900">
      {!selectedProtocol ? (
        <div className="max-w-6xl mx-auto px-4 py-12">
          <nav className="flex justify-between items-center mb-12">
            <div className="flex items-center space-x-2 text-blue-900">
              <Activity className="w-8 h-8" />
              <span className="text-2xl font-black tracking-tighter">ActiveRehab</span>
            </div>
            
            <div className="flex items-center space-x-4">
              {user ? (
                <div className="flex items-center space-x-4">
                  {isAdmin && (
                    <div className="flex space-x-2">
                      <button 
                        onClick={clearDatabase}
                        className="flex items-center px-4 py-2 bg-rose-50 text-rose-600 rounded-xl text-sm font-bold hover:bg-rose-100 transition-all border border-rose-100"
                      >
                        Clear DB
                      </button>
                      <button 
                        onClick={seedDatabase}
                        className="flex items-center px-4 py-2 bg-slate-100 text-slate-600 rounded-xl text-sm font-bold hover:bg-slate-200 transition-all"
                      >
                        Seed Database
                      </button>
                      <button className="flex items-center px-4 py-2 bg-emerald-600 text-white rounded-xl text-sm font-bold shadow-lg shadow-emerald-100 hover:bg-emerald-700 transition-all">
                        <Plus className="w-4 h-4 mr-2" />
                        Add Protocol
                      </button>
                    </div>
                  )}
                  <div className="flex items-center space-x-2 bg-white px-3 py-1.5 rounded-full border border-slate-200">
                    <img src={user.photoURL} alt={user.displayName} className="w-6 h-6 rounded-full" />
                    <span className="text-xs font-bold text-slate-600 hidden md:block">{user.displayName}</span>
                    <button onClick={handleLogout} className="text-slate-400 hover:text-rose-500 transition-colors">
                      <LogOut className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              ) : (
                <button 
                  onClick={handleLogin}
                  className="flex items-center px-6 py-2.5 bg-white text-slate-900 rounded-xl text-sm font-bold border border-slate-200 shadow-sm hover:shadow-md transition-all"
                >
                  <LogIn className="w-4 h-4 mr-2" />
                  Admin Login
                </button>
              )}
            </div>
          </nav>

          <header className="mb-16 text-center">
            <h1 className="text-6xl font-extrabold tracking-tight text-slate-900 mb-6">
              Clinical <span className="text-blue-600">Protocols</span>
            </h1>
            <p className="text-slate-500 text-xl max-w-2xl mx-auto leading-relaxed">
              Real-time synchronization with our medical database. Access 100+ Evidence-Based rehabilitation guidelines.
            </p>
          </header>

          <div className="bg-white rounded-[2rem] shadow-2xl shadow-slate-200/50 border border-slate-100 p-10 mb-12">
            <div className="flex flex-col lg:flex-row gap-8 items-center justify-between mb-10">
              <div className="relative w-full lg:w-1/3">
                <input 
                  type="text" 
                  placeholder="Filter protocols..." 
                  className="w-full pl-14 pr-4 py-4 bg-slate-50 border border-slate-100 rounded-2xl focus:ring-2 focus:ring-blue-500 focus:bg-white transition-all outline-none font-medium"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
                <Search className="absolute left-5 top-4.5 text-slate-400 w-5 h-5" />
              </div>

              <div className="flex flex-wrap gap-2 justify-center bg-slate-50 p-2 rounded-2xl">
                {categories.map(cat => (
                  <button
                    key={cat}
                    onClick={() => setActiveCategory(cat)}
                    className={`px-5 py-2 rounded-xl text-sm font-bold transition-all ${
                      activeCategory === cat 
                      ? 'bg-white text-blue-600 shadow-sm border border-slate-100' 
                      : 'text-slate-500 hover:text-slate-700'
                    }`}
                  >
                    {cat}
                  </button>
                ))}
              </div>
            </div>

            {protocols.length === 0 ? (
              <div className="text-center py-32 bg-slate-50/50 rounded-3xl border-2 border-dashed border-slate-100">
                <Activity className="w-16 h-16 text-slate-200 mx-auto mb-4" />
                <h3 className="text-xl font-bold text-slate-400 mb-2">No Protocols Found</h3>
                <p className="text-slate-400 text-sm">Please seed the database or check your connection.</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {filteredProtocols.map(p => (
                  <button
                    key={p.id}
                    onClick={() => setSelectedProtocol(p)}
                    className="text-left p-8 rounded-3xl border border-slate-100 bg-white hover:shadow-2xl hover:shadow-blue-100/50 hover:-translate-y-1 transition-all group"
                  >
                    <div className="flex justify-between items-start mb-4">
                      <span className="inline-block px-3 py-1 rounded-lg bg-blue-50 text-blue-600 text-[10px] font-black uppercase tracking-widest">
                        {p.category}
                      </span>
                    </div>
                    <h3 className="text-xl font-bold text-slate-800 leading-tight mb-4 group-hover:text-blue-600 transition-colors">
                      {p.name}
                    </h3>
                    <div className="flex items-center text-slate-400 text-[11px] font-bold uppercase tracking-wider">
                      <span className="flex items-center">
                        <Activity className="w-3 h-3 mr-1.5" />
                        {p.phases?.length || 0} Phases
                      </span>
                    </div>
                  </button>
                ))}
              </div>
            )}
          </div>
          
          <footer className="flex flex-col md:flex-row justify-between items-center text-slate-400 text-xs font-bold uppercase tracking-[0.2em] pt-8 border-t border-slate-200">
            <p>© 2026 ActiveRehab Labs</p>
            <div className="flex space-x-8 mt-4 md:mt-0">
              <span className="hover:text-blue-500 cursor-pointer transition-colors">Documentation</span>
              <span className="hover:text-blue-500 cursor-pointer transition-colors">Support</span>
              <span className="hover:text-blue-500 cursor-pointer transition-colors">API Access</span>
            </div>
          </footer>
        </div>
      ) : (
        <ProtocolDetail 
          protocol={selectedProtocol} 
          onBack={() => setSelectedProtocol(null)} 
        />
      )}
    </div>
  );
}
