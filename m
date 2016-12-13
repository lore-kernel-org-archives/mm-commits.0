From: akpm@linux-foundation.org
Subject: [to-be-updated]
 maintainers-clarify-that-b-is-the-uri-where-to-file-bugs.patch removed from -mm tree
Date: Mon, 12 Dec 2016 16:27:35 -0800
Message-ID: <584f4077.7Bz7NAQe0j0vZAQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932475AbcLMA0v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:26:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jani.nikula@intel.com, joe@perches.com, rafael.j.wysocki@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: clarify that "B:" is the URI where to file bugs
has been removed from the -mm tree.  Its filename was
     maintainers-clarify-that-b-is-the-uri-where-to-file-bugs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: MAINTAINERS: clarify that "B:" is the URI where to file bugs

Different subsystems and drivers have different preferences for where to
file bugs and what information to include. 686564434e88 ("MAINTAINERS:
Add bug tracking system location entry type") added "B:" entry for this.

Clarify that "B:" specifies the URI for the bug tracker directly, a web
page for detailed info on filing bugs, or a mailto: URI.

Fixes: 686564434e88 ("MAINTAINERS: Add bug tracking system location entry type")
Link: http://lkml.kernel.org/r/1480939439-27947-1-git-send-email-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-clarify-that-b-is-the-uri-where-to-file-bugs MAINTAINERS
--- a/MAINTAINERS~maintainers-clarify-that-b-is-the-uri-where-to-file-bugs
+++ a/MAINTAINERS
@@ -81,7 +81,8 @@ Descriptions of section entries:
 	Q: Patchwork web based patch tracking system site
 	T: SCM tree type and location.
 	   Type is one of: git, hg, quilt, stgit, topgit
-	B: Bug tracking system location.
+	B: URI for where to file bugs. A web-page with detailed bug
+	   filing info, a direct bug tracker link, or a mailto: URI.
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
 	   Maintained:	Someone actually looks after it.
_

Patches currently in -mm which might be from jani.nikula@intel.com are

maintainers-add-b-for-uri-where-to-file-bugs.patch
maintainers-add-drm-and-drm-i915-bug-filing-info.patch
maintainers-add-c-for-uri-for-chat-where-developers-hang-out.patch
maintainers-add-drm-and-drm-i915-irc-channels.patch

