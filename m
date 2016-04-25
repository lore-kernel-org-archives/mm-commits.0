From: akpm@linux-foundation.org
Subject: + maintainers-remove-defunct-spear-mailing-list.patch added to
 -mm tree
Date: Mon, 25 Apr 2016 13:33:55 -0700
Message-ID: <571e7f33.FdIwBsrqMaYZYpaW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbcDYUd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 16:33:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.engestrom@imgtec.com, davem@davemloft.net, gregkh@linuxfoundation.org, jslaby@suse.com, kvalo@codeaurora.org, linux@roeck-us.net, mchehab@osg.samsung.com, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove defunct spear mailing list
has been added to the -mm tree.  Its filename is
     maintainers-remove-defunct-spear-mailing-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-defunct-spear-mailing-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-defunct-spear-mailing-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Engestrom <eric.engestrom@imgtec.com>
Subject: MAINTAINERS: remove defunct spear mailing list

It looks like the email address for this mailing list doesn't exist anymore:
<spear-devel@list.st.com>: host mxb-00178001.gslb.pphosted.com[91.207.212.93] said:
550 5.1.1 User Unknown (in reply to RCPT TO command)

Signed-off-by: Eric Engestrom <eric.engestrom@imgtec.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jiri Slaby <jslaby@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ----
 1 file changed, 4 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-defunct-spear-mailing-list MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-defunct-spear-mailing-list
+++ a/MAINTAINERS
@@ -8728,7 +8728,6 @@ F:	drivers/pinctrl/pinctrl-single.c
 
 PIN CONTROLLER - ST SPEAR
 M:	Viresh Kumar <vireshk@kernel.org>
-L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
@@ -9932,7 +9931,6 @@ F:	drivers/mmc/host/sdhci-s3c*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
 M:	Viresh Kumar <vireshk@kernel.org>
-L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-spear.c
@@ -10488,7 +10486,6 @@ F:	include/linux/compiler.h
 SPEAR PLATFORM SUPPORT
 M:	Viresh Kumar <vireshk@kernel.org>
 M:	Shiraz Hashim <shiraz.linux.kernel@gmail.com>
-L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
@@ -10497,7 +10494,6 @@ F:	arch/arm/mach-spear/
 
 SPEAR CLOCK FRAMEWORK SUPPORT
 M:	Viresh Kumar <vireshk@kernel.org>
-L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
_

Patches currently in -mm which might be from eric.engestrom@imgtec.com are

maintainers-remove-defunct-spear-mailing-list.patch

