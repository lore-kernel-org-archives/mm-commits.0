From: akpm@linux-foundation.org
Subject: [merged] documentation-cpu-freq-governorstxt-fix-default-value-for-ondemand-governor.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:27:09 -0800
Message-ID: <200912182027.nBIKR95a016608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932754AbZLRU1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:27:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     Documentation/cpu-freq/governors.txt: fix default value for ondemand governor
has been removed from the -mm tree.  Its filename was
     documentation-cpu-freq-governorstxt-fix-default-value-for-ondemand-governor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/cpu-freq/governors.txt: fix default value for ondemand governor
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-freq/governors.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/cpu-freq/governors.txt~documentation-cpu-freq-governorstxt-fix-default-value-for-ondemand-governor Documentation/cpu-freq/governors.txt
--- a/Documentation/cpu-freq/governors.txt~documentation-cpu-freq-governorstxt-fix-default-value-for-ondemand-governor
+++ a/Documentation/cpu-freq/governors.txt
@@ -145,8 +145,8 @@ show_sampling_rate_max: THIS INTERFACE I
 up_threshold: defines what the average CPU usage between the samplings
 of 'sampling_rate' needs to be for the kernel to make a decision on
 whether it should increase the frequency.  For example when it is set
-to its default value of '80' it means that between the checking
-intervals the CPU needs to be on average more than 80% in use to then
+to its default value of '95' it means that between the checking
+intervals the CPU needs to be on average more than 95% in use to then
 decide that the CPU frequency needs to be increased.  
 
 ignore_nice_load: this parameter takes a value of '0' or '1'. When
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.patch

