Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B7FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jul 2022 14:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiGLObR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jul 2022 10:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiGLObR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2022 10:31:17 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B137165A1
        for <mm-commits@vger.kernel.org>; Tue, 12 Jul 2022 07:31:16 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lj34D3QgLzVfjq;
        Tue, 12 Jul 2022 22:27:24 +0800 (CST)
Received: from kwepemm600015.china.huawei.com (7.193.23.52) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 22:30:47 +0800
Received: from [10.174.176.52] (10.174.176.52) by
 kwepemm600015.china.huawei.com (7.193.23.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 22:30:46 +0800
Message-ID: <09f298f7-be26-579c-8e62-c617ce64a2ec@huawei.com>
Date:   Tue, 12 Jul 2022 22:30:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: + ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3.patch added to
 mm-hotfixes-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>,
        <mm-commits@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <yi.zhang@huawei.com>, <yin31149@gmail.com>,
        <liuyongqiang13@huawei.com>, <anton@tuxera.com>
References: <20220711204127.65342C341C0@smtp.kernel.org>
From:   "chenxiaosong (A)" <chenxiaosong2@huawei.com>
In-Reply-To: <20220711204127.65342C341C0@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.52]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600015.china.huawei.com (7.193.23.52)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

在 2022/7/12 4:41, Andrew Morton 写道:

> Cleanup quggested by Hawkins Jiawei

Hi Andrew:

Is "quggested" typo? Do you mean "suggested"?

