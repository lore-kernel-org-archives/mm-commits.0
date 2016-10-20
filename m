From: akpm@linux-foundation.org
Subject: + maintainers-add-drm-and-drm-i915-bug-filing-info.patch added to -mm tree
Date: Thu, 20 Oct 2016 15:43:10 -0700
Message-ID: <5809487e.rJSRG03th//n15/s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36417 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754719AbcJTWnL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2016 18:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jani.nikula@intel.com, airlied@gmail.com, daniel@ffwll.ch, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add drm and drm/i915 bug filing info
has been added to the -mm tree.  Its filename is
     maintainers-add-drm-and-drm-i915-bug-filing-info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-drm-and-drm-i915-bug-filing-info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-drm-and-drm-i915-bug-filing-info.patch

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
Subject: MAINTAINERS: add drm and drm/i915 bug filing info

Link: http://lkml.kernel.org/r/1476966135-26943-2-git-send-email-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-drm-and-drm-i915-bug-filing-info MAINTAINERS
--- a/MAINTAINERS~maintainers-add-drm-and-drm-i915-bug-filing-info
+++ a/MAINTAINERS
@@ -4006,6 +4006,7 @@ DRM DRIVERS
 M:	David Airlie <airlied@linux.ie>
 L:	dri-devel@lists.freedesktop.org
 T:	git git://people.freedesktop.org/~airlied/linux
+B:	https://bugs.freedesktop.org/
 S:	Maintained
 F:	drivers/gpu/drm/
 F:	drivers/gpu/vga/
@@ -4058,6 +4059,7 @@ M:	Jani Nikula <jani.nikula@linux.intel.
 L:	intel-gfx@lists.freedesktop.org
 L:	dri-devel@lists.freedesktop.org
 W:	https://01.org/linuxgraphics/
+B:	https://01.org/linuxgraphics/documentation/how-report-bugs
 Q:	http://patchwork.freedesktop.org/project/intel-gfx/
 T:	git git://anongit.freedesktop.org/drm-intel
 S:	Supported
_

Patches currently in -mm which might be from jani.nikula@intel.com are

maintainers-add-b-for-uri-where-to-file-bugs.patch
maintainers-add-drm-and-drm-i915-bug-filing-info.patch
maintainers-add-c-for-uri-for-chat-where-developers-hang-out.patch
maintainers-add-drm-and-drm-i915-irc-channels.patch

