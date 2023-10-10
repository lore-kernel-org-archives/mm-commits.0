Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1199CD98C0
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 23:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbjJJXDE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 19:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjJJXDD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 19:03:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5412E92
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 16:03:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD2CC433C7;
        Tue, 10 Oct 2023 23:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696978979;
        bh=PLbZvQtVMxDWdS39Xlg835BnF4CVmdzD5tj2CS6Xyc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LM4Z0vYUuwc/lzdUvKPJVdN8zUsAbQ9fkdOJvwsfCqmq/GvUma71tMwCLP2uDVObz
         SR2+vhlnSgizl0JsAASE5xpr0I5L4o1FzNomQEVbgKNfm3AFH8YofV7nSPKjl1HjKx
         cpQijtNUXHUrvaUpmg+I3mLWroWxFT9ugj7L3n0A=
Date:   Tue, 10 Oct 2023 16:02:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org
Subject: Re: + mm-kmem-add-direct-objcg-pointer-to-task_struct.patch added
 to mm-unstable branch
Message-Id: <20231010160239.abab599266e776b22450d90f@linux-foundation.org>
In-Reply-To: <ZSXM50e0iYOhm306@P9FQF9L96D.corp.robot.car>
References: <20231010182008.5441AC433C7@smtp.kernel.org>
        <ZSXM50e0iYOhm306@P9FQF9L96D.corp.robot.car>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 10 Oct 2023 15:15:03 -0700 Roman Gushchin <roman.gushchin@linux.dev> wrote:

> Andrew, can you, please, add
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> here?

yup, I've updated all five patches.
