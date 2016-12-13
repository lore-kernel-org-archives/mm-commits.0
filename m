From: akpm@linux-foundation.org
Subject: [patch 109/123] MAINTAINERS: add "B:" for URI where to file bugs
Date: Mon, 12 Dec 2016 16:46:02 -0800
Message-ID: <584f44ca.zJ5vtDOq1u2/WOFF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41950 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMAqD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jani.nikula@intel.com, andrew.donnellan@au1.ibm.com, daniel@ffwll.ch, joe@perches.com

From: Jani Nikula <jani.nikula@intel.com>
Subject: MAINTAINERS: add "B:" for URI where to file bugs

Different subsystems and drivers have different preferences for where to
file bugs and what information to include.  Add "B:" entry for specifying
the URI for the bug tracker directly, a web page for detailed info on
filing bugs, or a mailto: URI.

Link: http://lkml.kernel.org/r/1476966135-26943-1-git-send-email-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-b-for-uri-where-to-file-bugs MAINTAINERS
--- a/MAINTAINERS~maintainers-add-b-for-uri-where-to-file-bugs
+++ a/MAINTAINERS
@@ -74,6 +74,8 @@ Descriptions of section entries:
 	   These reviewers should be CCed on patches.
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
+	B: URI for where to file bugs. A web-page with detailed bug
+	   filing info, a direct bug tracker link, or a mailto: URI.
 	Q: Patchwork web based patch tracking system site
 	T: SCM tree type and location.
 	   Type is one of: git, hg, quilt, stgit, topgit
_
