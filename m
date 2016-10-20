From: akpm@linux-foundation.org
Subject: + maintainers-add-b-for-uri-where-to-file-bugs.patch added to -mm tree
Date: Thu, 20 Oct 2016 15:42:50 -0700
Message-ID: <5809486a.NJV0sMnWsTvXB03Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36365 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754719AbcJTWmw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2016 18:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jani.nikula@intel.com, daniel@ffwll.ch, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add "B:" for URI where to file bugs
has been added to the -mm tree.  Its filename is
     maintainers-add-b-for-uri-where-to-file-bugs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-b-for-uri-where-to-file-bugs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-b-for-uri-where-to-file-bugs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: MAINTAINERS: add "B:" for URI where to file bugs

Different subsystems and drivers have different preferences for where to
file bugs and what information to include.  Add "B:" entry for specifying
the URI for the bug tracker directly, a web page for detailed info on
filing bugs, or a mailto: URI.

Link: http://lkml.kernel.org/r/1476966135-26943-1-git-send-email-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
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

maintainers-add-b-for-uri-where-to-file-bugs.patch
maintainers-add-drm-and-drm-i915-bug-filing-info.patch
maintainers-add-c-for-uri-for-chat-where-developers-hang-out.patch
maintainers-add-drm-and-drm-i915-irc-channels.patch

