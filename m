From: akpm@linux-foundation.org
Subject: + init-kconfig-make-expert-as-config-instead-of-menuconfig.patch added to -mm tree
Date: Tue, 26 Mar 2013 12:17:39 -0700
Message-ID: <20130326191739.7438D5A41D7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42801 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3CZTRk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 15:17:40 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so755174vbi.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 12:17:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jovi.zhangwei@huawei.com, mmarek@suse.cz, rdunlap@infradead.org


The patch titled
     Subject: init/Kconfig: make EXPERT as config instead of menuconfig
has been added to the -mm tree.  Its filename is
     init-kconfig-make-expert-as-config-instead-of-menuconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~init-kconfig-make-expert-as-config-instead-of-menuconfig init/Kconfig
--- a/init/Kconfig~init-kconfig-make-expert-as-config-instead-of-menuconfig
+++ a/init/Kconfig
@@ -1236,7 +1236,7 @@ config SYSCTL
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
init-kconfig-make-expert-as-config-instead-of-menuconfig.patch

