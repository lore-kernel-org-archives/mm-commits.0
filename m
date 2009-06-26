From: akpm@linux-foundation.org
Subject: + rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch added to -mm tree
Date: Fri, 26 Jun 2009 16:01:46 -0700
Message-ID: <200906262301.n5QN1kxE022096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbZFZXBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 19:01:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: update documentation wrt RTC_PIE/irq_set_state
has been added to the -mm tree.  Its filename is
     rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch

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
Subject: rtc: update documentation wrt RTC_PIE/irq_set_state
From: Mike Frysinger <vapier@gentoo.org>


Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/rtc.txt~rtc-update-documentation-wrt-rtc_pie-irq_set_state Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-update-documentation-wrt-rtc_pie-irq_set_state
+++ a/Documentation/rtc.txt
@@ -185,6 +185,8 @@ driver returns ENOIOCTLCMD.  Some common
 	hardware in the irq_set_freq function.  If it isn't, return -EINVAL.  If
 	you cannot actually change the frequency, do not define irq_set_freq.
 
+    *	RTC_PIE_ON, RTC_PIE_OFF: the irq_set_state function will be called.
+
 If all else fails, check out the rtc-test.c driver!
 
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch
rtc-bfin-do-not-share-rtc-irq.patch
bfin-delay-irq-registration-until-driver-is-ready.patch

