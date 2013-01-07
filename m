From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-include-linux-of_pwmh.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:47 -0800
Message-ID: <20130107192647.9FD69100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:60143 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3AGT0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:48 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so2113584yhr.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove include/linux/of_pwm.h
has been removed from the -mm tree.  Its filename was
     maintainers-remove-include-linux-of_pwmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove include/linux/of_pwm.h

Added by commit 200efed ("pwm: Take over maintainership of the PWM
subsystem"), but I could not find any trace of that file being ever added
to the repository.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-include-linux-of_pwmh MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-include-linux-of_pwmh
+++ a/MAINTAINERS
@@ -6135,7 +6135,6 @@ T:	git git://gitorious.org/linux-pwm/lin
 F:	Documentation/pwm.txt
 F:	Documentation/devicetree/bindings/pwm/
 F:	include/linux/pwm.h
-F:	include/linux/of_pwm.h
 F:	drivers/pwm/
 F:	drivers/video/backlight/pwm_bl.c
 F:	include/linux/pwm_backlight.h
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

