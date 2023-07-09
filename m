Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59324EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjGIAaT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjGIAaS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C370C102
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61BC660B37
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA085C433C7;
        Sun,  9 Jul 2023 00:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862616;
        bh=9i3rdUIOQNcatLNHs4R1JILuyjbSQ9ZXU03DBZCa3qw=;
        h=Date:To:From:Subject:From;
        b=FfsmG3xPoqaiM0ZOo7QzSBYCtZIXYRW8LJGIU+WVDZgvCJoJ7qDwzpmc+c5af8k8m
         qPLmXobqNE21PUtI0Wz9rnaRDwwoViyyqKTxGAsgEgeXQIUrcRGQoExQWOprxpQjHa
         abAdTnCasXMbfkri7LZZF1K8zm8MiKS5txEzkYhU=
Date:   Sat, 08 Jul 2023 17:30:15 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, jiangqi903@gmail.com,
        ghe@suse.com, gechangwei@live.cn, ailiop@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-ocfs2-devel-mailing-list-address.patch removed from -mm tree
Message-Id: <20230709003016.AA085C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: update ocfs2-devel mailing list address
has been removed from the -mm tree.  Its filename was
     maintainers-update-ocfs2-devel-mailing-list-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anthony Iliopoulos <ailiop@suse.com>
Subject: MAINTAINERS: update ocfs2-devel mailing list address
Date: Wed, 28 Jun 2023 03:34:36 +0200

The ocfs2-devel mailing list has been migrated to the kernel.org
infrastructure, update the related entry to reflect the change.

Link: https://lkml.kernel.org/r/20230628013437.47030-2-ailiop@suse.com
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Acked-by: Joseph Qi <jiangqi903@gmail.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-ocfs2-devel-mailing-list-address
+++ a/MAINTAINERS
@@ -15922,7 +15922,7 @@ ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 M:	Mark Fasheh <mark@fasheh.com>
 M:	Joel Becker <jlbec@evilplan.org>
 M:	Joseph Qi <joseph.qi@linux.alibaba.com>
-L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
+L:	ocfs2-devel@lists.linux.dev
 S:	Supported
 W:	http://ocfs2.wiki.kernel.org
 F:	Documentation/filesystems/dlmfs.rst
_

Patches currently in -mm which might be from ailiop@suse.com are


