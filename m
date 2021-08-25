Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FA4C432BE
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 19:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3FE60EFE
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 19:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbhHYTSO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Aug 2021 15:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhHYTSN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Aug 2021 15:18:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9156C60F35;
        Wed, 25 Aug 2021 19:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629919047;
        bh=hHKXoGUKrGXDJg0LITArryk1r4O/jGCSTji+C53QonA=;
        h=Date:From:To:Cc:Subject:From;
        b=uZNVkDLNu6ujloVqteZYQcYNviET9ntqXL8XcCNxKgxk6p434Uf12ElOUDFTGBX4X
         dGyEtFGIYrP89+KxMS+N5nxLIcU3qZhK5cGEc5EBDkjl8Hk1Dj79LoRmOAYsaI1FuG
         6Mx4/NWX/Vo3OKVQzMG+FFxj/3W1+geVkv1qFW0E=
Date:   Wed, 25 Aug 2021 12:17:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210825121725.0b4f7ca217e22d9750bc6a6d@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

2 patches, based on 6e764bcd1cf72a2846c0e53d3975a09b242c04c9.

Subsystems affected by this patch series:

  mm/memory-hotplug
  MAINTAINERS

Subsystem: mm/memory-hotplug

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/memory_hotplug: fix potential permanent lru cache disable

Subsystem: MAINTAINERS

    Namjae Jeon <namjae.jeon@samsung.com>:
      MAINTAINERS: exfat: update my email address

 MAINTAINERS         |    2 +-
 mm/memory_hotplug.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

