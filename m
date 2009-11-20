From: akpm@linux-foundation.org
Subject: [merged] cpufreq-document-units-for-transition-latency.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:48 -0800
Message-ID: <200911201930.nAKJUm0k011557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbZKTTdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:33:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: document units for transition latency
has been removed from the -mm tree.  Its filename was
     cpufreq-document-units-for-transition-latency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: document units for transition latency
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

They're documented in the header but not in Documentation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-freq/cpu-drivers.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/cpu-freq/cpu-drivers.txt~cpufreq-document-units-for-transition-latency Documentation/cpu-freq/cpu-drivers.txt
--- a/Documentation/cpu-freq/cpu-drivers.txt~cpufreq-document-units-for-transition-latency
+++ a/Documentation/cpu-freq/cpu-drivers.txt
@@ -92,9 +92,9 @@ policy->cpuinfo.max_freq -	the minimum a
 				(in kHz) which is supported by 
 				this CPU
 policy->cpuinfo.transition_latency   the time it takes on this CPU to
-				switch between two frequencies (if
-				appropriate, else specify
-				CPUFREQ_ETERNAL)
+				switch between two frequencies in
+				nanoseconds (if appropriate, else
+				specify CPUFREQ_ETERNAL)
 
 policy->cur			The current operating frequency of
 				this CPU (if appropriate)
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

