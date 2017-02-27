From: akpm@linux-foundation.org
Subject: [patch 52/78] scripts/spelling.txt: add "againt" pattern and fix
 typo instances
Date: Mon, 27 Feb 2017 14:29:12 -0800
Message-ID: <58b4a838.BAKbTXvs0XTwBi18%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbdB0Wnv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:43:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "againt" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  againt||against

While we are here, fix the "capabilites" as well in the touched hunk
in drivers/gpu/drm/drm_probe_helper.c.

Link: http://lkml.kernel.org/r/1481573103-11329-13-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_probe_helper.c |    4 ++--
 fs/ecryptfs/kthread.c              |    2 +-
 scripts/spelling.txt               |    1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/gpu/drm/drm_probe_helper.c~scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances drivers/gpu/drm/drm_probe_helper.c
--- a/drivers/gpu/drm/drm_probe_helper.c~scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances
+++ a/drivers/gpu/drm/drm_probe_helper.c
@@ -220,8 +220,8 @@ drm_connector_detect(struct drm_connecto
  *    - drm_mode_validate_basic() performs basic sanity checks
  *    - drm_mode_validate_size() filters out modes larger than @maxX and @maxY
  *      (if specified)
- *    - drm_mode_validate_flag() checks the modes againt basic connector
- *      capabilites (interlace_allowed,doublescan_allowed,stereo_allowed)
+ *    - drm_mode_validate_flag() checks the modes against basic connector
+ *      capabilities (interlace_allowed,doublescan_allowed,stereo_allowed)
  *    - the optional &drm_connector_helper_funcs.mode_valid helper can perform
  *      driver and/or hardware specific checks
  *
diff -puN fs/ecryptfs/kthread.c~scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances fs/ecryptfs/kthread.c
--- a/fs/ecryptfs/kthread.c~scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances
+++ a/fs/ecryptfs/kthread.c
@@ -123,7 +123,7 @@ void ecryptfs_destroy_kthread(void)
  * @lower_dentry: Lower dentry for file to open
  * @lower_mnt: Lower vfsmount for file to open
  *
- * This function gets a r/w file opened againt the lower dentry.
+ * This function gets a r/w file opened against the lower dentry.
  *
  * Returns zero on success; non-zero otherwise
  */
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -62,6 +62,7 @@ adress||address
 adresses||addresses
 adviced||advised
 afecting||affecting
+againt||against
 agaist||against
 albumns||albums
 alegorical||allegorical
_
