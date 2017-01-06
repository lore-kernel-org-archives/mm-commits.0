From: akpm@linux-foundation.org
Subject: +
 config-android-base-enable-hardened-usercopy-and-kernel-aslr.patch added to -mm tree
Date: Fri, 06 Jan 2017 14:38:40 -0800
Message-ID: <58701c70.Z4ZTiSgoySfDJtZZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58406 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163120AbdAFWhU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2017 17:37:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit.pundir@linaro.org, danielmicay@gmail.com, john.stultz@linaro.org, rob.herring@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: config: android-base: enable hardened usercopy and kernel ASLR
has been added to the -mm tree.  Its filename is
     config-android-base-enable-hardened-usercopy-and-kernel-aslr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/config-android-base-enable-hardened-usercopy-and-kernel-aslr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/config-android-base-enable-hardened-usercopy-and-kernel-aslr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Amit Pundir <amit.pundir@linaro.org>
Subject: config: android-base: enable hardened usercopy and kernel ASLR

Enable CONFIG_HARDENED_USERCOPY and CONFIG_RANDOMIZE_BASE in Android
base config fragment.

Reviewed at https://android-review.googlesource.com/#/c/283659/
Reviewed at https://android-review.googlesource.com/#/c/278133/

Link: http://lkml.kernel.org/r/1481113148-29204-2-git-send-email-amit.pundir@linaro.org
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Cc: Rob Herring <rob.herring@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/android-base.config |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/configs/android-base.config~config-android-base-enable-hardened-usercopy-and-kernel-aslr kernel/configs/android-base.config
--- a/kernel/configs/android-base.config~config-android-base-enable-hardened-usercopy-and-kernel-aslr
+++ a/kernel/configs/android-base.config
@@ -21,6 +21,7 @@ CONFIG_CP15_BARRIER_EMULATION=y
 CONFIG_DEFAULT_SECURITY_SELINUX=y
 CONFIG_EMBEDDED=y
 CONFIG_FB=y
+CONFIG_HARDENED_USERCOPY=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_INET6_AH=y
 CONFIG_INET6_ESP=y
@@ -129,6 +130,7 @@ CONFIG_PPP_DEFLATE=y
 CONFIG_PPP_MPPE=y
 CONFIG_PREEMPT=y
 CONFIG_QUOTA=y
+CONFIG_RANDOMIZE_BASE=y
 CONFIG_RTC_CLASS=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_SECCOMP=y
_

Patches currently in -mm which might be from amit.pundir@linaro.org are

config-android-base-enable-hardened-usercopy-and-kernel-aslr.patch

