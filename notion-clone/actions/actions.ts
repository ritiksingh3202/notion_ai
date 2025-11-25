// 'use server';

// import { adminDb } from "@/firebase-admin";
// import { auth } from "@clerk/nextjs/server";

// export async function createNewDocument() {
//     auth().protect();

//     const { sessionClaims } = await auth();
//     const docCollectionRef = adminDb.collection("documents");
//     const docRef = await docCollectionRef.add({
//         title: "New Doc"
//     })

//     await adminDb.collection('users').doc(sessionClaims?.email!)
//     .collection('rooms').doc(docRef.id).set({
//         userId: sessionClaims?.email!,
//         role: "owner",
//         createdAt: new Date(),
//         roomId: docRef.id,
//     });

//     return { docId: docRef.id};
// }
'use server';

import { adminDb } from "@/firebase-admin";
import { auth } from "@clerk/nextjs/server";

interface DocumentResponse {
    docId: string;
    error?: string;
}

export async function createNewDocument(): Promise<DocumentResponse> {
    try {
        // Protect the route
        const authSession = await auth();
        authSession.protect();

        const { sessionClaims } = authSession;

        if (!sessionClaims?.email) {
            throw new Error('User email not found');
        }

        const docCollectionRef = adminDb.collection("documents");
        const docRef = await docCollectionRef.add({
            title: "New Doc",
            createdAt: new Date(),
            lastModified: new Date()
        });

        await adminDb.collection('users').doc(sessionClaims.email)
            .collection('rooms').doc(docRef.id).set({
                userId: sessionClaims.email,
                role: "owner",
                createdAt: new Date(),
                roomId: docRef.id,
            });

        return { docId: docRef.id };

    } catch (error) {
        console.error('Error creating document:', error);
        return {
            docId: '',
            error: error instanceof Error ? error.message : 'Failed to create document'
        };
    }
}