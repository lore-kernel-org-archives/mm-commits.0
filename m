From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch added
 to -mm tree
Date: Mon, 19 Dec 2016 14:26:32 -0800
Message-ID: <58585e98.uGrXAi37JJokTgMp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSWZd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "againt" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -207,8 +207,8 @@ drm_connector_detect(struct drm_connecto
  *    - drm_mode_validate_basic() performs basic sanity checks
  *    - drm_mode_validate_size() filters out modes larger than @maxX and @maxY
  *      (if specified)
- *    - drm_mode_validate_flag() checks the modes againt basic connector
- *      capabilites (interlace_allowed,doublescan_allowed,stereo_allowed)
+ *    - drm_mode_validate_flag() checks the modes against basic connector
+ *      capabilities (interlace_allowed,doublescan_allowed,stereo_allowed)
  *    - the optional connector ->mode_valid() helper can perform driver and/or
  *      hardware specific checks
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

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

