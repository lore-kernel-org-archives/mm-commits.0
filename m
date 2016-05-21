From: akpm@linux-foundation.org
Subject: [patch 086/162] MAINTAINERS: remove defunct spear mailing list
Date: Fri, 20 May 2016 17:00:49 -0700
Message-ID: <573fa531.b3zvf+yyI7B+2cNv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcEUAAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, eric.engestrom@imgtec.com, davem@davemloft.net, gregkh@linuxfoundation.org, jslaby@suse.com, kvalo@codeaurora.org, linux@roeck-us.net, mchehab@osg.samsung.com, viresh.kumar@linaro.org

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
@@ -8812,7 +8812,6 @@ F:	drivers/pinctrl/pinctrl-single.c
 
 PIN CONTROLLER - ST SPEAR
 M:	Viresh Kumar <vireshk@kernel.org>
-L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
@@ -10016,7 +10015,6 @@ F:	drivers/mmc/host/sdhci-s3c*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
 M:	Viresh Kumar <vireshk@kernel.org>
-L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-spear.c
@@ -10579,7 +10577,6 @@ F:	include/linux/compiler.h
 SPEAR PLATFORM SUPPORT
 M:	Viresh Kumar <vireshk@kernel.org>
 M:	Shiraz Hashim <shiraz.linux.kernel@gmail.com>
-L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
@@ -10588,7 +10585,6 @@ F:	arch/arm/mach-spear/
 
 SPEAR CLOCK FRAMEWORK SUPPORT
 M:	Viresh Kumar <vireshk@kernel.org>
-L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
_
