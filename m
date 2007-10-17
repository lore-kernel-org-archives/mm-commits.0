From: akpm@linux-foundation.org
Subject: + cpufreq-fix-incorrect-comment-on-show_available_freqs-in-freq_tablec.patch added to -mm tree
Date: Wed, 17 Oct 2007 15:51:31 -0700
Message-ID: <200710172251.l9HMpV3S012359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758206AbXJQWwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 18:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fenghua.yu@intel.com, davej@codemonkey.org.uk


The patch titled
     cpufreq: fix incorrect comment on show_available_freqs() in freq_table.c
has been added to the -mm tree.  Its filename is
     cpufreq-fix-incorrect-comment-on-show_available_freqs-in-freq_tablec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cpufreq-fix-incorrect-comment-on-show_available_freqs-in-freq_tablec.patch
