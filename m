From: akpm@linux-foundation.org
Subject: - add-sys-kernel-notes-fix.patch removed from -mm tree
Date: Wed, 18 Jul 2007 22:52:25 -0700
Message-ID: <200707190552.l6J5qPvI016549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbXGSFxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, paulus@samba.org, roland@redhat.com, rth@twiddle.net, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add-sys-kernel-notes-fix
has been removed from the -mm tree.  Its filename was
     add-sys-kernel-notes-fix.patch

This patch was dropped because it was folded into add-sys-kernel-notes.patch

------------------------------------------------------
Subject: add-sys-kernel-notes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <ak@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ksysfs.c~add-sys-kernel-notes-fix kernel/ksysfs.c
--- a/kernel/ksysfs.c~add-sys-kernel-notes-fix
+++ a/kernel/ksysfs.c
@@ -69,7 +69,7 @@ extern const char __start_notes __attrib
 extern const char __stop_notes __attribute__((weak));
 #define	notes_size (&__stop_notes - &__start_notes)
 
-static ssize_t notes_read(struct kobject *kobj,
+static ssize_t notes_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
 	memcpy(buf, &__start_notes + off, count);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
add-sys-kernel-notes.patch
add-sys-kernel-notes-fix.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks-fix.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
