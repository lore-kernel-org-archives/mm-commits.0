From: akpm@linux-foundation.org
Subject: + cpufreq-document-units-for-transition-latency.patch added to -mm tree
Date: Mon, 16 Nov 2009 12:49:03 -0800
Message-ID: <200911162049.nAGKn361004448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbZKPUtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 15:49:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, davej@codemonkey.org.uk


The patch titled
     cpufreq: document units for transition latency
has been added to the -mm tree.  Its filename is
     cpufreq-document-units-for-transition-latency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
cpufreq-document-units-for-transition-latency.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

