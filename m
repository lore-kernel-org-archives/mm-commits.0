Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF06C54E76
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 23:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjKPXyN convert rfc822-to-8bit (ORCPT
        <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 18:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjKPXyN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 18:54:13 -0500
X-Greylist: delayed 477 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Nov 2023 15:54:10 PST
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3671AA5
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 15:54:10 -0800 (PST)
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay03.hostedemail.com (Postfix) with ESMTP id AB8EAA0D3F;
        Thu, 16 Nov 2023 23:46:11 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 54DB12000D;
        Thu, 16 Nov 2023 23:46:09 +0000 (UTC)
Message-ID: <6cd1eb26c8f9c39f02af32d801540ce7b52c807b.camel@perches.com>
Subject: Re: + checkpatch-add-judgment-condition-for-kconfig-help-test.patch
 added to mm-nonmm-unstable branch
From:   Joe Perches <joe@perches.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        lukas.bulwahn@gmail.com, dwaipayanray1@gmail.com,
        cixi.geng1@unisoc.com
Date:   Thu, 16 Nov 2023 15:46:08 -0800
In-Reply-To: <20231116215339.EB805C433C7@smtp.kernel.org>
References: <20231116215339.EB805C433C7@smtp.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 54DB12000D
X-Rspamd-Server: rspamout02
X-Stat-Signature: mkrern3pwfi1euxox3b8ztyd6u59uwee
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/A2eikKMWHaIRzUHF8TfnjhSUPlHwhhzM=
X-HE-Tag: 1700178369-223712
X-HE-Meta: U2FsdGVkX1+BbBkorhrMgSgMb8CqE7WwqAkJZCOrdytIIvz6uCqQorgK9vdoK2J0/bUYSiEiJDsJWQZPCg77gYh1X5kcUU+d3OnsOd0OjzOeWHz4kvN57USlvSEWgkywukcbAU2u9VTfKHPcGJc0rMJQwpVMMN2D4iJQY8mVK/wMWKls4Kzizhqt98rpiCNDVeQCUHsIC9qVrJ6r4O6DxWObFnJEaXBYxtC5MqGZvjSbFkLSW5N0mKmBSklu2OxKBr3tDyGyRoXuE6eyi8DgNA6W89oQGJZxCcRuXvwe0gJfw5Z0xWBCYfUVLv/kDZqI
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 2023-11-16 at 13:53 -0800, Andrew Morton wrote:
> The patch titled
>      Subject: checkpatch: add judgment condition for Kconfig help test
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      checkpatch-add-judgment-condition-for-kconfig-help-test.patch

I think this is not a good patch as now it will generate
false positives on additions above help when help is not
modified.

