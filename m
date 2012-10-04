From: akpm@linux-foundation.org
Subject: [folded-dropped] audith-replace-defines-with-c-stubs-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:52:29 -0700
Message-ID: <20121004235231.10EE41E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63579 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2JDXwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:52:33 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so137887qae.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:52:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: audith-replace-defines-with-c-stubs-fix
has been removed from the -mm tree.  Its filename was
     audith-replace-defines-with-c-stubs-fix.patch

This patch was dropped because it was folded into audith-replace-defines-with-c-stubs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: audith-replace-defines-with-c-stubs-fix

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/audit.h~audith-replace-defines-with-c-stubs-fix include/linux/audit.h
--- a/include/linux/audit.h~audith-replace-defines-with-c-stubs-fix
+++ a/include/linux/audit.h
@@ -530,7 +530,7 @@ extern int auditsc_get_stamp(struct audi
 			      struct timespec *t, unsigned int *serial);
 extern int audit_set_loginuid(kuid_t loginuid);
 
-static inline int audit_get_loginuid(struct task_struct *tsk)
+static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
 	return tsk->loginuid;
 }
@@ -677,7 +677,7 @@ static inline int auditsc_get_stamp(stru
 {
 	return 0;
 }
-static inline int audit_get_loginuid(struct task_struct *tsk)
+static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
 	return INVALID_UID;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

