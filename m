From: akpm@linux-foundation.org
Subject: [folded] numa-emulation-x86_64-documentation-changes-in-boot-optionstxt.patch removed from -mm tree
Date: Fri, 18 Nov 2011 11:53:53 -0800
Message-ID: <201111181953.pAIJrrhc031800@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:34798 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1KRTx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2011 14:53:57 -0500
Received: by faap16 with SMTP id p16so107488faa.1
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2011 11:53:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pholasek@redhat.com, hpa@zytor.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: NUMA emulation x86_64: Documentation changes in boot-options.txt
has been removed from the -mm tree.  Its filename was
     numa-emulation-x86_64-documentation-changes-in-boot-optionstxt.patch

This patch was dropped because it was folded into numa-emulation-x86_64-numa=fake-parameter-for-custom-nodes-distance.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Petr Holasek <pholasek@redhat.com>
Subject: NUMA emulation x86_64: Documentation changes in boot-options.txt

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86/x86_64/boot-options.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/x86/x86_64/boot-options.txt~numa-emulation-x86_64-documentation-changes-in-boot-optionstxt Documentation/x86/x86_64/boot-options.txt
--- a/Documentation/x86/x86_64/boot-options.txt~numa-emulation-x86_64-documentation-changes-in-boot-optionstxt
+++ a/Documentation/x86/x86_64/boot-options.txt
@@ -166,13 +166,15 @@ NUMA
 
   numa=noacpi   Don't parse the SRAT table for NUMA setup
 
-  numa=fake=<size>[MG]
+  numa=fake=<size>[MG][,distance]
 		If given as a memory unit, fills all system RAM with nodes of
 		size interleaved over physical nodes.
+		Optional distance sets linear distance between emulated nodes.
 
-  numa=fake=<N>
+  numa=fake=<N>[,distance]
 		If given as an integer, fills all system RAM with N fake nodes
 		interleaved over physical nodes.
+		Optional distance sets linear distance between emulated nodes.
 
 ACPI
 
_

Patches currently in -mm which might be from pholasek@redhat.com are

numa-emulation-x86_64-numa=fake-parameter-for-custom-nodes-distance.patch

