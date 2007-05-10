From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-documentation-update.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:30 -0700
Message-ID: <200705102232.l4AMWUM8032626@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759381AbXEJWch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-documentation update
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-documentation-update.patch

This patch was dropped because an updated version will be merged

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
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
