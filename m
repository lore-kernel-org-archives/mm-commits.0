From: akpm@linux-foundation.org
Subject: [folded-merged] epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:15:47 -0700
Message-ID: <20130430221547.7FCBB5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:56498 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761183Ab3D3WPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:15:48 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so113785vbf.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:15:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, normalperson@yhbt.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll-trim-epitem-by-one-cache-line-on-x86_64-fix
has been removed from the -mm tree.  Its filename was
     epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch

This patch was dropped because it was folded into epoll-trim-epitem-by-one-cache-line-on-x86_64.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: epoll-trim-epitem-by-one-cache-line-on-x86_64-fix

use __packed, for all architectures

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Wong <normalperson@yhbt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64-fix
+++ a/fs/eventpoll.c
@@ -105,7 +105,7 @@
 struct epoll_filefd {
 	struct file *file;
 	int fd;
-} EPOLL_PACKED;
+} __packed;
 
 /*
  * Structure used to track possible nested calls, for too deep recursions
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch

