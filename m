Return-Path: <SRS0=RNAI=BY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C554C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 02:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5E272078B
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 02:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597373693;
	bh=VHcfKEyW7MgnExK2ca5g1IDRUaWJ/tqYuIJL4JWLTDE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=j9zOxq4qTwaOpvY4FgG1uF84EBO6xD0Q6qJKroYuWtKSiyMFA2OXxaabBwQ1+Bbeq
	 itwQwjCPo48h4ANBjdU7m3XR1NkGJWck57I6Fa5Omgm5Ycf7JdGxe8YRpwqeCn8tPU
	 ZSZ7F/NXlvK8jHEBVoPondBpEoTLULuqmaN3rndw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHNCyx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Aug 2020 22:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgHNCyx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Aug 2020 22:54:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9981620768;
        Fri, 14 Aug 2020 02:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597373692;
        bh=VHcfKEyW7MgnExK2ca5g1IDRUaWJ/tqYuIJL4JWLTDE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Bq8NyJ8hgqqpn9RFXOGIkk5IY/yHVQk3hLzDWcxpznO47witll2N0Zn6hF4DIEW/r
         ppcZVA0/QkiBvQW5nlykVT0MW2Lxw6UmMEOIwk7oFHY/YexOnsX0GqSlgEBO4sL3Bb
         IWfNGjhIKbuNp8Xai4yGSQoeL0XTbHMJapR6K8hw=
Date:   Thu, 13 Aug 2020 19:54:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     groug@kaod.org, mm-commits@vger.kernel.org
Subject:  + mailmap-add-entry-for-greg-kurz.patch added to -mm tree
Message-ID: <20200814025452.9ajtI9owD%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for Greg Kurz
has been added to the -mm tree.  Its filename is
     mailmap-add-entry-for-greg-kurz.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mailmap-add-entry-for-greg-kurz.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mailmap-add-entry-for-greg-kurz.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Kurz <groug@kaod.org>
Subject: mailmap: add entry for Greg Kurz

I had stopped using gkurz@linux.vnet.ibm.com a while back already but this
email address was shutdown last June when I quit IBM.  It's about time to
map it to groug@kaod.org.

Link: http://lkml.kernel.org/r/159724692879.76040.4938578139173154028.stgit@bahia.lan
Signed-off-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-greg-kurz
+++ a/.mailmap
@@ -104,6 +104,7 @@ Gerald Schaefer <gerald.schaefer@linux.i
 Greg Kroah-Hartman <greg@echidna.(none)>
 Greg Kroah-Hartman <gregkh@suse.de>
 Greg Kroah-Hartman <greg@kroah.com>
+Greg Kurz <groug@kaod.org> <gkurz@linux.vnet.ibm.com>
 Gregory CLEMENT <gregory.clement@bootlin.com> <gregory.clement@free-electrons.com>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
_

Patches currently in -mm which might be from groug@kaod.org are

mailmap-add-entry-for-greg-kurz.patch

