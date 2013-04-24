From: akpm@linux-foundation.org
Subject: [wrecked] init-kconfig-make-expert-as-config-instead-of-menuconfig.patch removed from -mm tree
Date: Wed, 24 Apr 2013 13:05:23 -0700
Message-ID: <20130424200523.D36C55A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:47068 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593Ab3DXUFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 16:05:24 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so236871yen.2
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 13:05:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, mmarek@suse.cz, rdunlap@infradead.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: make EXPERT as config instead of menuconfig
has been removed from the -mm tree.  Its filename was
     init-kconfig-make-expert-as-config-instead-of-menuconfig.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Subject: init/Kconfig: make EXPERT as config instead of menuconfig

There don't have any EXPERT menu guard, and no config item is included in
EXPERT menu, so change it as a config, not menu.

This will make user more clear when they use 'make menuconfig'
or 'make nconfig'.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~init-kconfig-make-expert-as-config-instead-of-menuconfig init/Kconfig
--- a/init/Kconfig~init-kconfig-make-expert-as-config-instead-of-menuconfig
+++ a/init/Kconfig
@@ -1238,7 +1238,7 @@ config SYSCTL
 config ANON_INODES
 	bool
 
-menuconfig EXPERT
+config EXPERT
 	bool "Configure standard kernel features (expert users)"
 	# Unhide debug options, to make the on-by-default options visible
 	select DEBUG_KERNEL
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

linux-next.patch
printk-tracing-rework-console-tracing.patch
relay-remove-unused-function-argument-actor.patch
relay-move-fix_size-macro-into-relayc.patch
relay-use-macro-page_align-instead-of-fix_size.patch
relay-fix-timer-madness.patch
kernel-relayc-move-remove_buf_file-inside-relay_close_buf.patch
kgdb-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
power-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
arm-etm-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
powerpc-xmon-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
spare-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
ethernet-emac-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
documentation-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

