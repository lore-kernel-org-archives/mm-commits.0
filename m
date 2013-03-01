From: akpm@linux-foundation.org
Subject: [failures] hfsplus-add-all-necessary-declarations-for-acls-support-fix.patch removed from -mm tree
Date: Fri, 01 Mar 2013 15:47:45 -0800
Message-ID: <20130301234745.8DDDA31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:64536 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3CAXrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 18:47:46 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so397384qea.5
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 15:47:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus-add-all-necessary-declarations-for-acls-support-fix
has been removed from the -mm tree.  Its filename was
     hfsplus-add-all-necessary-declarations-for-acls-support-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hfsplus-add-all-necessary-declarations-for-acls-support-fix

fix build

fs/hfsplus/acl.c: In function 'hfsplus_process_one_ace':
fs/hfsplus/acl.c:302: error: expected expression before 'do'
fs/hfsplus/acl.c: In function 'hfsplus_compose_filesec_from_posix_acl':         fs/hfsplus/acl.c:1037: error: expected expression before 'do'
fs/hfsplus/acl.c:1050: error: expected expression before 'do'
fs/hfsplus/acl.c:1071: error: expected expression before 'do'                   fs/hfsplus/acl.c:1084: error: expected expression before 'do'

Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-add-all-necessary-declarations-for-acls-support-fix fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-add-all-necessary-declarations-for-acls-support-fix
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -42,8 +42,8 @@
 #define dprint_hexdump(flg, prefix, ptr, size) \
 	do { \
 		if ((flg) & (DBG_MASK)) \
-			(print_hex_dump_bytes((prefix), \
-				(DUMP_PREFIX_NONE), (ptr), (size))); \
+			print_hex_dump_bytes((prefix), \
+				(DUMP_PREFIX_NONE), (ptr), (size)); \
 	} while (0)
 
 /* Runtime config options */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
shmem-fix-build-regression-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

