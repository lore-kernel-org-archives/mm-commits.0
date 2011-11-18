From: akpm@linux-foundation.org
Subject: + numa-emulation-x86_64-documentation-changes-in-boot-optionstxt.patch added to -mm tree
Date: Fri, 18 Nov 2011 11:51:20 -0800
Message-ID: <201111181951.pAIJpKum014419@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:65377 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1KRTvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2011 14:51:24 -0500
Received: by eyg5 with SMTP id 5so80968eyg.1
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2011 11:51:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pholasek@redhat.com, hpa@zytor.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de


The patch titled
     Subject: NUMA emulation x86_64: Documentation changes in boot-options.txt
has been added to the -mm tree.  Its filename is
     numa-emulation-x86_64-documentation-changes-in-boot-optionstxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: NUMA emulation x86_64: Documentation changes in boot-options.txt

Patches currently in -mm which might be from pholasek@redhat.com are

numa-emulation-x86_64-numa=fake-parameter-for-custom-nodes-distance.patch
numa-emulation-x86_64-documentation-changes-in-boot-optionstxt.patch

