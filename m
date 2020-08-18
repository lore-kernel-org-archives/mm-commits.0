Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C691DC433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9527E20709
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790160;
	bh=pcvu5oj1xSEmjN1uTiW+bENqcrHdnniCcq7YJ0/6BSY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0dAj8WUBpm+Wwzhy6s3Elf1btg6oSTkfM5zHHLAIJ1kgCt4zZaxVx4ONAgozdbR3l
	 JG4vWc/lhhmbtAnTfhWIPCBXAznPNOVwnbFaS5NATNZfiAtriO5nqahBwIZCt0Up7T
	 LnelePw4Pkdpokq8ao/uhsmwI4LfH+8uro9zAHBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHRWgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgHRWgA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:36:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B25920709;
        Tue, 18 Aug 2020 22:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790159;
        bh=pcvu5oj1xSEmjN1uTiW+bENqcrHdnniCcq7YJ0/6BSY=;
        h=Date:From:To:Subject:From;
        b=nh1sx57bfc6ShN21Ye9aSqv8+j3r1WnZ25MAyHu47z+JEgiPEI0EDLJf+7DYs9Eqj
         LiaAOLb3s7B1+/9IIsMTlfBNem12mcTtaWckoOSyzZ3x9d+YGQEWA9w9YuIdXcXh10
         FuYzzSlfe1cMpD5olazAZe1WpjySxidVgBeB1Kmk=
Date:   Tue, 18 Aug 2020 15:35:58 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20200818223558.vhTQlPN8b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/.mailmap~linux-next-rejects
+++ a/.mailmap
@@ -94,20 +94,22 @@ Felix Kuhling <fxkuehl@gmx.de>
 Felix Moeller <felix@derklecks.de>
 Filipe Lautert <filipe@icewall.org>
 Franck Bui-Huu <vagabon.xyz@gmail.com>
-Frank Rowand <frowand.list@gmail.com> <frowand@mvista.com>
 Frank Rowand <frowand.list@gmail.com> <frank.rowand@am.sony.com>
 Frank Rowand <frowand.list@gmail.com> <frank.rowand@sonymobile.com>
+Frank Rowand <frowand.list@gmail.com> <frowand@mvista.com>
 Frank Zago <fzago@systemfabricworks.com>
 Gao Xiang <xiang@kernel.org> <gaoxiang25@huawei.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@aol.com>
-Gerald Schaefer <gerald.schaefer@linux.ibm.com> <gerald.schaefer@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@de.ibm.com>
+Gerald Schaefer <gerald.schaefer@linux.ibm.com> <gerald.schaefer@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@linux.vnet.ibm.com>
 Greg Kroah-Hartman <greg@echidna.(none)>
 Greg Kroah-Hartman <gregkh@suse.de>
 Greg Kroah-Hartman <greg@kroah.com>
 Greg Kurz <groug@kaod.org> <gkurz@linux.vnet.ibm.com>
 Gregory CLEMENT <gregory.clement@bootlin.com> <gregory.clement@free-electrons.com>
+Gustavo Padovan <gustavo@las.ic.unicamp.br>
+Gustavo Padovan <padovan@profusion.mobi>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

