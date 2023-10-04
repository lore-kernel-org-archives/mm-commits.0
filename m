Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511DDE8FDD1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 08:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjJDIPG convert rfc822-to-8bit (ORCPT
        <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 04:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjJDIPG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 04:15:06 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD4483
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 01:14:58 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-208-m4MihYZcOLqaH2h4c-Pekw-1; Wed, 04 Oct 2023 09:14:54 +0100
X-MC-Unique: m4MihYZcOLqaH2h4c-Pekw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 4 Oct
 2023 09:14:53 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Wed, 4 Oct 2023 09:14:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Morton' <akpm@linux-foundation.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: RE: [failures] compilerh-move-__is_constexpr-to-compilerh.patch
 removed from -mm tree
Thread-Topic: [failures] compilerh-move-__is_constexpr-to-compilerh.patch
 removed from -mm tree
Thread-Index: AQHZ9lNHGDI/c05H80CNcGw3N38tG7A5SNtA
Date:   Wed, 4 Oct 2023 08:14:53 +0000
Message-ID: <e82afc60ad0741a99c0980cb17b3679a@AcuMS.aculab.com>
References: <20231003234225.15C03C433C7@smtp.kernel.org>
In-Reply-To: <20231003234225.15C03C433C7@smtp.kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrew Morton
> Sent: 04 October 2023 00:42
> 
> 
> The quilt patch titled
>      Subject: compiler.h: move __is_constexpr() to compiler.h
> has been removed from the -mm tree.  Its filename was
>      compilerh-move-__is_constexpr-to-compilerh.patch
> 
> This patch was dropped because it had testing failures

Any hint as to where?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

