From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 07 Feb 2018 11:54:46 -0800
Message-ID: <20180207195446.hQGbdYKSw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGTys (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:54:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/process/maintainer-pgp-guide.rst |   58 ---------------
 drivers/platform/x86/dell-laptop.c             |    3 
 2 files changed, 61 deletions(-)

diff -puN Documentation/process/maintainer-pgp-guide.rst~linux-next-git-rejects Documentation/process/maintainer-pgp-guide.rst
--- a/Documentation/process/maintainer-pgp-guide.rst~linux-next-git-rejects
+++ a/Documentation/process/maintainer-pgp-guide.rst
@@ -18,17 +18,10 @@ The role of PGP in Linux Kernel developm
 ===========================================
 
 PGP helps ensure the integrity of the code that is produced by the Linux
-<<<<<<< HEAD
-kernel development community and, to a lesser degree, establish trusted
-communication channels between developers via PGP-signed email exchange.
-
-The Linux kernel source code is available in two main formats:
-=======
 Kernel development community and, to a lesser degree, establish trusted
 communication channels between developers via PGP-signed email exchange.
 
 The Linux Kernel source code is available in two main formats:
->>>>>>> linux-next/akpm-base
 
 - Distributed source repositories (git)
 - Periodic release snapshots (tarballs)
@@ -60,11 +53,7 @@ want to make sure that by placing trust
 shift the blame for potential future security incidents to someone else.
 The goal is to provide a set of guidelines developers can use to create
 a secure working environment and safeguard the PGP keys used to
-<<<<<<< HEAD
-establish the integrity of the Linux kernel itself.
-=======
 establish the integrity of the Linux Kernel itself.
->>>>>>> linux-next/akpm-base
 
 .. _pgp_tools:
 
@@ -150,11 +139,7 @@ Protect your master PGP key
 ===========================
 
 This guide assumes that you already have a PGP key that you use for Linux
-<<<<<<< HEAD
-kernel development purposes. If you do not yet have one, please see the
-=======
 Kernel development purposes. If you do not yet have one, please see the
->>>>>>> linux-next/akpm-base
 "`Protecting Code Integrity`_" document mentioned earlier for guidance
 on how to create a new one.
 
@@ -164,13 +149,7 @@ You should also make a new key if your c
 Master key vs. Subkeys
 ----------------------
 
-<<<<<<< HEAD
-Subkeys are fully independent PGP keypairs that are tied to the "master"
-key using certifying key signatures (certificates). It is important to
-understand the following:
-=======
 It is important to understand the following:
->>>>>>> linux-next/akpm-base
 
 1. There are no technical differences between the "master key" and "subkeys."
 2. At creation time, we assign functional limitations to each key by
@@ -763,31 +742,6 @@ How to work with signed commits
 -------------------------------
 
 It is easy to create signed commits, but it is much more difficult to
-<<<<<<< HEAD
-use them in Linux kernel development, since it relies on patches sent to
-the mailing list, and this workflow does not preserve PGP commit
-signatures. Furthermore, when rebasing your repository to match
-upstream, even your own PGP commit signatures will end up discarded. For
-this reason, most kernel developers don't bother signing their commits
-and will ignore signed commits in any external repositories that they
-rely upon in their work.
-
-However, if you have your working git tree publicly available at some
-git hosting service (kernel.org, infradead.org, ozlabs.org, or others),
-then the recommendation is that you sign all your git commits even if
-upstream developers do not directly benefit from this practice.
-
-We recommend this for the following reasons:
-
-1. Should there ever be a need to perform code forensics or track code
-   provenance, even externally maintained trees carrying PGP commit
-   signatures will be valuable for such purposes.
-2. If you ever need to re-clone your local repository (for example,
-   after a disk failure), this lets you easily verify the repository
-   integrity before resuming your work.
-3. If someone needs to cherry-pick your commits, this allows them to
-   quickly verify their integrity before applying them.
-=======
 use them in Linux Kernel development, since it relies on patches sent to
 the mailing list, and this workflow does not preserve PGP commit
 signatures.
@@ -799,7 +753,6 @@ developers do not directly benefit from
 be a need to perform code forensics or track code provenance, even
 externally maintained trees carrying PGP commit signatures will be
 extremely valuable for such purposes.
->>>>>>> linux-next/akpm-base
 
 Creating signed commits
 ~~~~~~~~~~~~~~~~~~~~~~~
@@ -817,13 +770,6 @@ You can tell git to always sign commits:
 
     git config --global commit.gpgSign true
 
-<<<<<<< HEAD
-.. note::
-
-    Make sure you configure ``gpg-agent`` before you turn this on.
-
-=======
->>>>>>> linux-next/akpm-base
 .. _verify_identities:
 
 How to verify kernel developer identities
@@ -936,11 +882,7 @@ Locate the ID of the master key in the o
 ``C94035C21B4F2AEB``. Now display the key of Linus Torvalds that you
 have on your keyring::
 
-<<<<<<< HEAD
-    $ gpg --list-key torvalds@kernel.org
-=======
     $ git --list-key torvalds@kernel.org
->>>>>>> linux-next/akpm-base
     pub   rsa2048 2011-09-20 [SC]
           ABAF11C65A2970B130ABE3C479BE3E4300411886
     uid           [ unknown] Linus Torvalds <torvalds@kernel.org>
diff -puN drivers/platform/x86/dell-laptop.c~linux-next-git-rejects drivers/platform/x86/dell-laptop.c
--- a/drivers/platform/x86/dell-laptop.c~linux-next-git-rejects
+++ a/drivers/platform/x86/dell-laptop.c
@@ -1217,12 +1217,9 @@ static int kbd_get_info(struct kbd_info
 	info->triggers = buffer.output[2] & 0xFF;
 	units = (buffer.output[2] >> 8) & 0xFF;
 	info->levels = (buffer.output[2] >> 16) & 0xFF;
-<<<<<<< HEAD
-=======
 
 	if (quirks && quirks->kbd_led_levels_off_1 && info->levels)
 		info->levels--;
->>>>>>> linux-next/akpm-base
 
 	if (quirks && quirks->kbd_led_levels_off_1 && info->levels)
 		info->levels--;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

