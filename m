From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-b-for-uri-where-to-file-bugs.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:27:29 -0800
Message-ID: <58519d21.eqkDnfXoWpDAclwt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45832 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756531AbcLNT2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jani.nikula@intel.com, andrew.donnellan@au1.ibm.com, daniel@ffwll.ch, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add "B:" for URI where to file bugs
has been removed from the -mm tree.  Its filename was
     maintainers-add-b-for-uri-where-to-file-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jani.nikula@intel.com are


