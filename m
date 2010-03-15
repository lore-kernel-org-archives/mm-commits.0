From: akpm@linux-foundation.org
Subject: [merged] intelfb-new-maintainer.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:58 -0400
Message-ID: <201003150657.o2F6vVfW016376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935007Ab0COG6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mbroemme@plusserver.de, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org, krzysztof.h1@poczta.fm, sylvain.meyer@worldonline.fr, mm-commits@vger.kernel.org


The patch titled
     intelfb: new maintainer
has been removed from the -mm tree.  Its filename was
     intelfb-new-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intelfb: new maintainer
From: Maik Broemme <mbroemme@plusserver.de>

It seems that Sylvain no longer maintain the intelfb driver.  Two weeks
ago I had a short mail conversation with Jean regarding who can replace
him.  Well I will do it, because I know the driver and use it very often. 

Attached is a patch which update the maintainer file to make bug reporting
easier.

Signed-off-by: Maik Broemme <mbroemme@plusserver.de>
Sylvain Meyer <sylvain.meyer@worldonline.fr>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~intelfb-new-maintainer MAINTAINERS
--- a/MAINTAINERS~intelfb-new-maintainer
+++ a/MAINTAINERS
@@ -2811,7 +2811,7 @@ S:	Maintained
 F:	drivers/input/
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
-M:	Sylvain Meyer <sylvain.meyer@worldonline.fr>
+M:	Maik Broemme <mbroemme@plusserver.de>
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/fb/intelfb.txt
_

Patches currently in -mm which might be from mbroemme@plusserver.de are

origin.patch

