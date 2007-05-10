From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-documentation-update.patch added to -mm tree
Date: Wed, 09 May 2007 20:44:39 -0700
Message-ID: <200705100344.l4A3idBn011255@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355AbXEJDov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 23:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org


The patch titled
     linux-kernel-markers-documentation update
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-documentation-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: linux-kernel-markers-documentation update
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Here is some documentation explaining what is/how to use the Linux
Kernel Markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/marker.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/marker.txt~linux-kernel-markers-documentation-update Documentation/marker.txt
--- a/Documentation/marker.txt~linux-kernel-markers-documentation-update
+++ a/Documentation/marker.txt
@@ -74,8 +74,8 @@ optimization can be disabled through men
 
 The MF_* flags can be used to control the type of marker. See the
 include/marker.h header for the list of flags. They can be specified as the
-first parameter of the _trace_mark() macro, such as the following example which is
-safe with respect to lockdep.c (useful for marking lockdep.c and printk
+first parameter of the _trace_mark() macro, such as the following example which
+is safe with respect to lockdep.c (useful for marking lockdep.c and printk
 functions).
 
 _trace_mark(MF_DEFAULT | ~MF_LOCKDEP, subsystem_eventb, MARK_NOARGS);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
x86_64-fix-default_do_nmi-missing-return-after-a-if.patch
git-avr32.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-update.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-update.patch
allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-update.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
