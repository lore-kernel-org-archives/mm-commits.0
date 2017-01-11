From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 11 Jan 2017 14:27:05 -0800
Message-ID: <5876b139.WVnOX4tm/4te1FzA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbdAKW1c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:27:32 -0500
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

 net/core/sock.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN net/core/sock.c~linux-next-git-rejects net/core/sock.c
--- a/net/core/sock.c~linux-next-git-rejects
+++ a/net/core/sock.c
@@ -222,11 +222,8 @@ static const char *const af_family_key_s
   "sk_lock-AF_RXRPC" , "sk_lock-AF_ISDN"     , "sk_lock-AF_PHONET"   ,
   "sk_lock-AF_IEEE802154", "sk_lock-AF_CAIF" , "sk_lock-AF_ALG"      ,
   "sk_lock-AF_NFC"   , "sk_lock-AF_VSOCK"    , "sk_lock-AF_KCM"      ,
-<<<<<<< HEAD
   "sk_lock-AF_QIPCRTR", "sk_lock-AF_MAX"
-=======
   "sk_lock-AF_SMC"   , "sk_lock-AF_MAX"
->>>>>>> linux-next/akpm-base
 };
 static const char *const af_family_slock_key_strings[AF_MAX+1] = {
   "slock-AF_UNSPEC", "slock-AF_UNIX"     , "slock-AF_INET"     ,
@@ -243,11 +240,8 @@ static const char *const af_family_slock
   "slock-AF_RXRPC" , "slock-AF_ISDN"     , "slock-AF_PHONET"   ,
   "slock-AF_IEEE802154", "slock-AF_CAIF" , "slock-AF_ALG"      ,
   "slock-AF_NFC"   , "slock-AF_VSOCK"    ,"slock-AF_KCM"       ,
-<<<<<<< HEAD
   "slock-AF_QIPCRTR", "slock-AF_MAX"
-=======
   "slock-AF_SMC"   , "slock-AF_MAX"
->>>>>>> linux-next/akpm-base
 };
 static const char *const af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_UNSPEC", "clock-AF_UNIX"     , "clock-AF_INET"     ,
@@ -264,11 +258,8 @@ static const char *const af_family_clock
   "clock-AF_RXRPC" , "clock-AF_ISDN"     , "clock-AF_PHONET"   ,
   "clock-AF_IEEE802154", "clock-AF_CAIF" , "clock-AF_ALG"      ,
   "clock-AF_NFC"   , "clock-AF_VSOCK"    , "clock-AF_KCM"      ,
-<<<<<<< HEAD
   "clock-AF_QIPCRTR", "clock-AF_MAX"
-=======
   "closck-AF_smc"  , "clock-AF_MAX"
->>>>>>> linux-next/akpm-base
 };
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

