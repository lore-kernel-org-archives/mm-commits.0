From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-adp5520-pattern.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:39 -0700
Message-ID: <201103232043.p2NKhFnb028846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933452Ab1CWUnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update ADP5520 pattern
has been removed from the -mm tree.  Its filename was
     maintainers-update-adp5520-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update ADP5520 pattern
From: Joe Perches <joe@perches.com>

Typo in path.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-adp5520-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-adp5520-pattern
+++ a/MAINTAINERS
@@ -346,7 +346,7 @@ W:	http://wiki-analog.com/ADP5520
 S:	Supported
 F:	drivers/mfd/adp5520.c
 F:	drivers/video/backlight/adp5520_bl.c
-F:	drivers/led/leds-adp5520.c
+F:	drivers/leds/leds-adp5520.c
 F:	drivers/gpio/adp5520-gpio.c
 F:	drivers/input/keyboard/adp5520-keys.c
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

