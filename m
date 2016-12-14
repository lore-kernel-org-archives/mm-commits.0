From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-c-for-uri-for-chat-where-developers-hang-out.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:27:34 -0800
Message-ID: <58519d26.lswWlEPaV8tJnEU6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756548AbcLNT2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jani.nikula@intel.com, airlied@gmail.com, andrew.donnellan@au1.ibm.com, daniel@ffwll.ch, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add "C:" for URI for chat where developers hang out
has been removed from the -mm tree.  Its filename was
     maintainers-add-c-for-uri-for-chat-where-developers-hang-out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: MAINTAINERS: add "C:" for URI for chat where developers hang out

Make it easier to find the developer chat for the subsystem or driver.

Link: http://lkml.kernel.org/r/1476966135-26943-3-git-send-email-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-c-for-uri-for-chat-where-developers-hang-out MAINTAINERS
--- a/MAINTAINERS~maintainers-add-c-for-uri-for-chat-where-developers-hang-out
+++ a/MAINTAINERS
@@ -76,6 +76,8 @@ Descriptions of section entries:
 	W: Web-page with status/info
 	B: URI for where to file bugs. A web-page with detailed bug
 	   filing info, a direct bug tracker link, or a mailto: URI.
+	C: URI for chat protocol, server and channel where developers
+	   usually hang out, for example irc://server/channel.
 	Q: Patchwork web based patch tracking system site
 	T: SCM tree type and location.
 	   Type is one of: git, hg, quilt, stgit, topgit
_

Patches currently in -mm which might be from jani.nikula@intel.com are


