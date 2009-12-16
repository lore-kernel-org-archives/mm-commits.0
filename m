From: akpm@linux-foundation.org
Subject: + documentation-cpu-freq-governorstxt-fix-default-value-for-ondemand-governor.patch added to -mm tree
Date: Wed, 16 Dec 2009 14:31:15 -0800
Message-ID: <200912162231.nBGMVFK1018682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935448AbZLPWbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 17:31:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, davej@codemonkey.org.uk


The patch titled
     Documentation/cpu-freq/governors.txt: fix default value for ondemand governor
has been added to the -mm tree.  Its filename is
     documentation-cpu-freq-governorstxt-fix-default-value-for-ondemand-governor.patch

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

origin.patch
linux-next.patch
documentation-cpu-freq-governorstxt-fix-default-value-for-ondemand-governor.patch
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.patch
spidev-add-proper-section-markers.patch

