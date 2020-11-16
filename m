Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308EAC2D0A3
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 837F920B80
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="lDlMa3hH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387441AbgKPUls (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731972AbgKPUlr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Nov 2020 15:41:47 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71765C0613CF
        for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2020 12:41:47 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CZgwS2qzNz9sSs;
        Tue, 17 Nov 2020 07:41:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1605559304;
        bh=Fm/u6V9tZR9cVEvo9wk1YsdJwIQ3D6qqKuy1UcdTPs4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lDlMa3hHZhUS/b8dKO5Tx9n9s1k2aot1Y7yloO/yd2dMZrjqPJCQdBFQ7/U3WxPzW
         QaeBpvsWB/17mqipRuh2mXaxwIkAKkeS+0L30TlZ2ETqcbDhxy4BgUASI/DKgkrfvi
         +D4wyw+dZwBSZ40qfUlCtYh4ExeFlxbn+dGsiJfGFATK7M1xX8Il0g8BQV33RKzgj6
         Sujq7HnHw7iEcSAzQTqBvvWnK+wguHDkVFXeCndS8ab2ERJgBpINDyWazrBc8ulrzU
         fKZ2vHZuxnExvFsvrj7qPumAi/kaE+vIr/hsHHF4LFOlHJSCUDvrSymaE2MNou62Bh
         cgoCrsqyqU0Lw==
Date:   Tue, 17 Nov 2020 07:41:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject: Re: +
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch added to
 -mm tree
Message-ID: <20201117074136.1ee71722@canb.auug.org.au>
In-Reply-To: <20201116201902.YUGWWZpX2%akpm@linux-foundation.org>
References: <20201116201902.YUGWWZpX2%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4NXtCcShoNT+l8Tf0tzNNiV";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/4NXtCcShoNT+l8Tf0tzNNiV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 16 Nov 2020 12:19:02 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: lib/cmdline_kunit: provide meaningful MODULE_LICENSE()
> has been added to the -mm tree.  Its filename is
>      lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/4NXtCcShoNT+l8Tf0tzNNiV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+y5AAACgkQAVBC80lX
0GzbpQf+L4A01RUPq0RpHnHVPsLe68Yf8HS23QGT9HToYlUiaZzk5Yx6lxQ48fNn
83lxiFChLE+0hqbi481gi9/iCiJD56T8PzKFs9CEfIrE0xsHt0OkHyCuMNDWgzv0
rXT7s8OsZCPutMJNT3/7wxRn6ikGpbmdGg9Vsig6ipof6Sar2tSOsahg8V/Sawr0
asrmPSgOev3NveyiMWf4+ujmpITHc8nnkPacEZSfL3WhmcDQH/ns1PiYB4XfcPOt
q85KYCOQCckttM9AH3tSDaYfr5X88EgiNKjuGyjtnVpAqUgwTn5V9pwysXOXiX72
NXZQ5Yr0qs+w6IXVKal14ZFLrQPevA==
=lbJZ
-----END PGP SIGNATURE-----

--Sig_/4NXtCcShoNT+l8Tf0tzNNiV--
