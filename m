From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-picoxcell-patterns.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:17 -0700
Message-ID: <53ea6e55.zTq4BDVU+VXzXm/q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:61212 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaHLTnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:18 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so1920152oac.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jamie@jamieiles.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update picoxcell patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-picoxcell-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update picoxcell patterns

Fix the picoxcell patterns, add the dts directory too.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Jamie Iles <jamie@jamieiles.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-picoxcell-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-picoxcell-patterns
+++ a/MAINTAINERS
@@ -6959,9 +6959,9 @@ M:	Jamie Iles <jamie@jamieiles.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://github.com/jamieiles/linux-2.6-ji.git
 S:	Supported
+F:	arch/arm/boot/dts/picoxcell*
 F:	arch/arm/mach-picoxcell/
-F:	drivers/*/picoxcell*
-F:	drivers/*/*/picoxcell*
+F:	drivers/crypto/picoxcell*
 
 PIN CONTROL SUBSYSTEM
 M:	Linus Walleij <linus.walleij@linaro.org>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

