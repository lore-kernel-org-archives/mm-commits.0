From: akpm@linux-foundation.org
Subject: [folded-merged] mm-rcu-protected-get_mm_exe_file-fix-2.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 10:44:27 -0700
Message-ID: <552ff4fb.lAvA6FNS1GH2a+KQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbbDPRo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 13:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rcu-protected-get_mm_exe_file-fix-2
has been removed from the -mm tree.  Its filename was
     mm-rcu-protected-get_mm_exe_file-fix-2.patch

This patch was dropped because it was folded into mm-rcu-protected-get_mm_exe_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rcu-protected-get_mm_exe_file-fix-2

fix comment typo

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~mm-rcu-protected-get_mm_exe_file-fix-2 kernel/fork.c
--- a/kernel/fork.c~mm-rcu-protected-get_mm_exe_file-fix-2
+++ a/kernel/fork.c
@@ -709,7 +709,7 @@ EXPORT_SYMBOL_GPL(mmput);
 /**
  * set_mm_exe_file - change a reference to the mm's executable file
  *
- * This changes mm's executale file (shown as symlink /proc/[pid]/exe).
+ * This changes mm's executable file (shown as symlink /proc/[pid]/exe).
  *
  * Main users are mmput(), sys_execve() and sys_prctl(PR_SET_MM_MAP/EXE_FILE).
  * Callers prevent concurrent invocations: in mmput() nobody alive left,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file.patch

