From: akpm@linux-foundation.org
Subject: [patch 111/123] MAINTAINERS: add "C:" for URI for chat where
 developers hang out
Date: Mon, 12 Dec 2016 16:46:08 -0800
Message-ID: <584f44d0.18q/ObMl/sPlgznS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932592AbcLMAqJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jani.nikula@intel.com, airlied@gmail.com, andrew.donnellan@au1.ibm.com, daniel@ffwll.ch, joe@perches.com

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
