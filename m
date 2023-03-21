Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118DBC6FD1D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCUVpF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCUVpE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:45:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124144483
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:45:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E6094CE1024
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4290C433D2;
        Tue, 21 Mar 2023 21:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679435097;
        bh=A90yqpdTClldI2XcgokvT4NbmwQu73tGMnq9O5qRDVU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OckCCasTa9uTNNWBnD3b9RAZeks4OW3S+05IuptpRHdkfZ+ZpzJfRfX7ANhfqgM6u
         864TnzzTq3O1TQ4wEQyacOmsHw37qa6S7l9edoEBi0bP/u+3nHkwKhD6yr8NfXBbem
         DzI4gpdrLLWx59+d7DgSkVnJAjJP+0qMg0nh7slc=
Date:   Tue, 21 Mar 2023 14:44:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Rob Herring <robh@kernel.org>
Cc:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        krzysztof.kozlowski@linaro.org, joe@perches.com,
        dwaipayanray1@gmail.com, apw@canonical.com,
        ddrokosov@sberdevices.ru
Subject: Re: + checkpatch-add-missing-bindings-license-check.patch added to
 mm-nonmm-unstable branch
Message-Id: <20230321144456.a70b235ca64424d3f73a1ac7@linux-foundation.org>
In-Reply-To: <CAL_JsqJ2mibR5EKjk494V1T9GsSCwF+5yVB9A3nEntgcrmoTkA@mail.gmail.com>
References: <20230321212913.79232C4339B@smtp.kernel.org>
        <CAL_JsqJ2mibR5EKjk494V1T9GsSCwF+5yVB9A3nEntgcrmoTkA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 21 Mar 2023 16:40:29 -0500 Rob Herring <robh@kernel.org> wrote:

> > Link: https://lkml.kernel.org/r/20230320203350.13696-1-ddrokosov@sberdevices.ru
> 
> Not a correct link.

Not a helpful comment.

What's wrong with it?
