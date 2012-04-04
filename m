From: akpm@linux-foundation.org
Subject: + nfs-inotify-inotify-user-when-deleting-files-on-nfs-fix.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:52:38 -0700
Message-ID: <20120404225239.1C4BBA0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:53936 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2DDWwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:52:40 -0400
Received: by yhgm50 with SMTP id m50so105366yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:52:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bharrosh@panasas.com, chuck.lever@oracle.com, eparis@redhat.com, maxim.uvarov@oracle.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     Subject: nfs-inotify-inotify-user-when-deleting-files-on-nfs-fix
has been added to the -mm tree.  Its filename is
     nfs-inotify-inotify-user-when-deleting-files-on-nfs-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nfs-inotify-inotify-user-when-deleting-files-on-nfs-fix

tweak the comment

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Maxim Uvarov <maxim.uvarov@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~nfs-inotify-inotify-user-when-deleting-files-on-nfs-fix fs/namei.c
--- a/fs/namei.c~nfs-inotify-inotify-user-when-deleting-files-on-nfs-fix
+++ a/fs/namei.c
@@ -2856,10 +2856,10 @@ int vfs_unlink(struct inode *dir, struct
 		if (!(dentry->d_flags & DCACHE_NFSFS_RENAMED))
 			d_delete(dentry);
 		else {
-			/* We don't d_delete() NFS sillyrenamed files - they
-			 * still exist. But from user side this file was
-			 * deleted. So that we need to generate notify event
-			 * about it.
+			/*
+			 * We don't d_delete() NFS sillyrenamed files - they
+			 * still exist.  But from the user side this file was
+			 * deleted, so we need to generate a notify event.
 			 */
 			struct inode *inode;
 			int isdir;
_
Subject: Subject: nfs-inotify-inotify-user-when-deleting-files-on-nfs-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
nfs-inotify-inotify-user-when-deleting-files-on-nfs-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-2.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

