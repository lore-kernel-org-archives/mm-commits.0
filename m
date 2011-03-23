From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-asoc-codec-drivers-files-not-in-tree.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:43 -0700
Message-ID: <201103232043.p2NKhJfT028852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933436Ab1CWUny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove ASOC CODEC DRIVERS files not in tree
has been removed from the -mm tree.  Its filename was
     maintainers-remove-asoc-codec-drivers-files-not-in-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove ASOC CODEC DRIVERS files not in tree
From: Joe Perches <joe@perches.com>

Remove these patterns until such files are actually in the tree.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-asoc-codec-drivers-files-not-in-tree MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-asoc-codec-drivers-files-not-in-tree
+++ a/MAINTAINERS
@@ -531,8 +531,6 @@ L:	alsa-devel@alsa-project.org (moderate
 W:	http://wiki.analog.com/
 S:	Supported
 F:	sound/soc/codecs/ad1*
-F:	sound/soc/codecs/adau*
-F:	sound/soc/codecs/adav*
 F:	sound/soc/codecs/ssm*
 
 ANALOG DEVICES INC ASOC DRIVERS
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

