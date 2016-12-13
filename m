From: akpm@linux-foundation.org
Subject: [patch 112/123] MAINTAINERS: add drm and drm/i915 irc channels
Date: Mon, 12 Dec 2016 16:46:11 -0800
Message-ID: <584f44d3.HQNaLuijeQoAW2Pl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41992 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932592AbcLMAqM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jani.nikula@intel.com, airlied@gmail.com, andrew.donnellan@au1.ibm.com, daniel@ffwll.ch, joe@perches.com

From: Jani Nikula <jani.nikula@intel.com>
Subject: MAINTAINERS: add drm and drm/i915 irc channels

Link: http://lkml.kernel.org/r/1476966135-26943-4-git-send-email-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-drm-and-drm-i915-irc-channels MAINTAINERS
--- a/MAINTAINERS~maintainers-add-drm-and-drm-i915-irc-channels
+++ a/MAINTAINERS
@@ -4029,6 +4029,7 @@ M:	David Airlie <airlied@linux.ie>
 L:	dri-devel@lists.freedesktop.org
 T:	git git://people.freedesktop.org/~airlied/linux
 B:	https://bugs.freedesktop.org/
+C:	irc://chat.freenode.net/dri-devel
 S:	Maintained
 F:	drivers/gpu/drm/
 F:	drivers/gpu/vga/
@@ -4082,6 +4083,7 @@ L:	intel-gfx@lists.freedesktop.org
 L:	dri-devel@lists.freedesktop.org
 W:	https://01.org/linuxgraphics/
 B:	https://01.org/linuxgraphics/documentation/how-report-bugs
+C:	irc://chat.freenode.net/intel-gfx
 Q:	http://patchwork.freedesktop.org/project/intel-gfx/
 T:	git git://anongit.freedesktop.org/drm-intel
 S:	Supported
_
