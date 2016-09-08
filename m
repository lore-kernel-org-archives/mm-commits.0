From: akpm@linux-foundation.org
Subject: + config-android-set-selinux-as-default-security-mode.patch added to -mm tree
Date: Thu, 08 Sep 2016 15:05:08 -0700
Message-ID: <57d1e094.HK9rYQI+rqV0UEYy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45619 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932233AbcIHWFJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 18:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robh@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: config: android: set SELinux as default security mode
has been added to the -mm tree.  Its filename is
     config-android-set-selinux-as-default-security-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/config-android-set-selinux-as-default-security-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/config-android-set-selinux-as-default-security-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Herring <robh@kernel.org>
Subject: config: android: set SELinux as default security mode

Android won't boot without SELinux enabled, so make it the default.

Link: http://lkml.kernel.org/r/20160908185934.18098-2-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/android-base.config |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/configs/android-base.config~config-android-set-selinux-as-default-security-mode kernel/configs/android-base.config
--- a/kernel/configs/android-base.config~config-android-set-selinux-as-default-security-mode
+++ a/kernel/configs/android-base.config
@@ -18,6 +18,7 @@ CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_CP15_BARRIER_EMULATION=y
+CONFIG_DEFAULT_SECURITY_SELINUX=y
 CONFIG_EMBEDDED=y
 CONFIG_FB=y
 CONFIG_HIGH_RES_TIMERS=y
_

Patches currently in -mm which might be from robh@kernel.org are

config-android-move-device-mapper-options-to-recommended.patch
config-android-set-selinux-as-default-security-mode.patch
config-android-enable-config_seccomp.patch

