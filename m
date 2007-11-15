From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-document-format-string.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:00 -0800
Message-ID: <200711152110.lAFLA0K4015507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759617AbXKOVQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: document format string
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-document-format-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Linux Kernel Markers: document format string
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Describes the format string standard further: Use of field names before the
type specifiers..

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/markers.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/markers.txt~linux-kernel-markers-document-format-string Documentation/markers.txt
--- a/Documentation/markers.txt~linux-kernel-markers-document-format-string
+++ a/Documentation/markers.txt
@@ -35,12 +35,14 @@ In order to use the macro trace_mark, yo
 
 And,
 
-trace_mark(subsystem_event, "%d %s", someint, somestring);
+trace_mark(subsystem_event, "myint %d mystring %s", someint, somestring);
 Where :
 - subsystem_event is an identifier unique to your event
     - subsystem is the name of your subsystem.
     - event is the name of the event to mark.
-- "%d %s" is the formatted string for the serializer.
+- "myint %d mystring %s" is the formatted string for the serializer. "myint" and
+  "mystring" are repectively the field names associated with the first and
+  second parameter.
 - someint is an integer.
 - somestring is a char pointer.
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
add-cmpxchg_local-to-arm.patch
add-cmpxchg_local-to-avr32.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
add-cmpxchg_local-to-cris.patch
add-cmpxchg_local-to-frv.patch
add-cmpxchg_local-to-h8300.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
fix-m32r-__xchg.patch
m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
local_t-m32r-use-architecture-specific-cmpxchg_local.patch
add-cmpxchg_local-to-m86k.patch
add-cmpxchg_local-to-m68knommu.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
