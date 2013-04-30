From: akpm@linux-foundation.org
Subject: [folded-merged] usermodehelper-export-_exec-and-_setup-functions-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:17:56 -0700
Message-ID: <20130430221756.CF7175A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:56504 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3D3WR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:17:58 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so114260vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:17:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, james.l.morris@oracle.com, lucas.demarchi@profusion.mobi, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper-export-_exec-and-_setup-functions-fix
has been removed from the -mm tree.  Its filename was
     usermodehelper-export-_exec-and-_setup-functions-fix.patch

This patch was dropped because it was folded into usermodehelper-export-_exec-and-_setup-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: usermodehelper-export-_exec-and-_setup-functions-fix

export call_usermodehelper_setup() to modules

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kmod.c~usermodehelper-export-_exec-and-_setup-functions-fix kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-export-_exec-and-_setup-functions-fix
+++ a/kernel/kmod.c
@@ -541,6 +541,7 @@ struct subprocess_info *call_usermodehel
   out:
 	return sub_info;
 }
+EXPORT_SYMBOL(call_usermodehelper_setup);
 
 /**
  * call_usermodehelper_exec - start a usermode application
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
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
usermodehelper-export-_exec-and-_setup-functions.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch

