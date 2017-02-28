From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:27 -0800
Message-ID: <58b5e2cf.OiBZ8O0YG+IWMFpu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52762 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbdB1Uvg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "againt" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

