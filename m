From: akpm@linux-foundation.org
Subject: - cpufreq-fix-incorrect-comment-on-show_available_freqs-in-freq_tablec.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:15 -0800
Message-ID: <200711272033.lARKXFGj028967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34150 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755461AbXK0Ud2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenghua.yu@intel.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: fix incorrect comment on show_available_freqs() in freq_table.c
has been removed from the -mm tree.  Its filename was
     cpufreq-fix-incorrect-comment-on-show_available_freqs-in-freq_tablec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpufreq: fix incorrect comment on show_available_freqs() in freq_table.c
From: Fenghua Yu <fenghua.yu@intel.com>

In freq_table.c, show_available_freqs()'s comment is oberviously wrong. 
Change the comment to a new one to avoid confusion.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/freq_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/freq_table.c~cpufreq-fix-incorrect-comment-on-show_available_freqs-in-freq_tablec drivers/cpufreq/freq_table.c
--- a/drivers/cpufreq/freq_table.c~cpufreq-fix-incorrect-comment-on-show_available_freqs-in-freq_tablec
+++ a/drivers/cpufreq/freq_table.c
@@ -171,7 +171,7 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_tabl
 
 static struct cpufreq_frequency_table *show_table[NR_CPUS];
 /**
- * show_scaling_governor - show the current policy for the specified CPU
+ * show_available_freqs - show available frequencies for the specified CPU
  */
 static ssize_t show_available_freqs (struct cpufreq_policy *policy, char *buf)
 {
_

Patches currently in -mm which might be from fenghua.yu@intel.com are

git-cpufreq.patch
